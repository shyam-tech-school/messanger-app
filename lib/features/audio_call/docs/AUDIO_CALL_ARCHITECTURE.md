# Audio Call Architecture (WebRTC + Firebase)

## 1. Overall Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         CALLER (User A)                                          │
│  1. Request mic permission                                                       │
│  2. Create RTCPeerConnection (STUN/TURN)                                         │
│  3. Get local MediaStream (audio only) → addTrack                                │
│  4. createOffer() → setLocalDescription(offer)                                  │
│  5. Write to Firestore: calls/{callId} { offer, status: 'ringing', callerId }   │
│  6. Listen: calls/{callId} for answer + status                                   │
│  7. Listen: calls/{callId}/candidates (callee's ICE) → addIceCandidate          │
│  8. Send own ICE candidates to Firestore: calls/{callId}/candidates             │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        │ Firestore (signaling)
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         FIREBASE FIRESTORE                                        │
│  Collection: calls                                                               │
│    Document: {callId}                                                             │
│      - callerId, calleeId, offer (SDP), answer (SDP), status                      │
│      - createdAt, endedAt                                                         │
│    Subcollection: candidates                                                     │
│      - Documents: {candidateId} { sdpMid, sdpMLineIndex, candidate }             │
│      - Caller writes "caller" type; callee writes "callee" type                   │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         CALLEE (User B)                                          │
│  1. Listen: calls (where calleeId == myId) OR listen to specific callId           │
│  2. On new call doc with status 'ringing' → show incoming call UI                 │
│  3. On Accept: Request mic → Create RTCPeerConnection                             │
│  4. setRemoteDescription(offer) → createAnswer() → setLocalDescription(answer)  │
│  5. Write answer to calls/{callId} + set status: 'connected'                     │
│  6. Listen: calls/{callId}/candidates (caller's ICE) → addIceCandidate           │
│  7. Send own ICE candidates to candidates subcollection                           │
│  8. On connection: play remote audio stream                                      │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        │ WebRTC peer connection (after signaling)
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         PEER-TO-PEER AUDIO                                       │
│  Direct RTP audio between User A and User B (via STUN/TURN if needed)             │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## 2. Firestore Collections & Document Structure

### `calls` (collection)

| Field      | Type   | Description                                      |
|-----------|--------|--------------------------------------------------|
| callId    | string | Document ID = callId                             |
| callerId  | string | Firebase Auth UID of caller                      |
| calleeId  | string | Firebase Auth UID of callee                      |
| offer     | map    | `{ type: 'offer', sdp: string }` (optional once answer is set) |
| answer    | map    | `{ type: 'answer', sdp: string }` (set by callee) |
| status    | string | `ringing` \| `connected` \| `ended` \| `rejected` |
| createdAt | timestamp | When call was created                         |
| endedAt   | timestamp | When call ended (optional)                     |
| callerName / calleeName | string | Optional display names for UI           |

### `calls/{callId}/candidates` (subcollection)

| Field         | Type   | Description                |
|---------------|--------|----------------------------|
| type          | string | `caller` or `callee`       |
| sdpMid        | string | ICE candidate sdpMid       |
| sdpMLineIndex | int    | ICE candidate sdpMLineIndex|
| candidate     | string | ICE candidate string       |
| createdAt     | timestamp | For ordering            |

### When and how PeerConnection is created

- **Caller**: PeerConnection is created when user taps "Call" (before writing offer to Firestore). Local stream is added, then `createOffer()` → `setLocalDescription` → write offer to Firestore. ICE candidate handler writes each candidate to `candidates` subcollection.
- **Callee**: PeerConnection is created when user taps "Accept". Then `setRemoteDescription(offer)` → `createAnswer()` → `setLocalDescription(answer)` → write answer to Firestore. ICE candidate handler writes to `candidates`. Listener on `candidates` adds remote ICE candidates via `addIceCandidate`.
- **Cleanup**: On call end or rejection, both sides call `peerConnection.close()` and remove Firestore listeners. Document can be updated to `status: 'ended'` for history.

## 3. Call State Handling

| Status     | Caller UI           | Callee UI           |
|-----------|---------------------|---------------------|
| ringing   | Outgoing call screen| Incoming call screen|
| connected | In-call screen      | In-call screen      |
| ended     | Back to previous    | Back to previous    |
| rejected  | Call rejected toast | —                   |

## 4. Edge Cases (summary)

- **Call rejection**: Callee writes `status: 'rejected'`; caller listener gets it and cleans up.
- **User offline**: Caller can set a timeout; if no answer, set status to `ended` and cleanup.
- **App background/killed**: Use Firestore persistence; on resume, re-attach listeners or show "call ended".
- **ICE failure**: Listen to `iceConnectionState`; if `failed` or `disconnected`, show reconnecting or end call.

## 5. Best Practices

- **Firestore listener cleanup**: Cancel all `StreamSubscription`s and `snapshots()` listeners in a single cleanup method (e.g. when leaving call screen or ending call).
- **WebRTC resource cleanup**: `peerConnection.close()`, stop all tracks on local and remote streams, set references to null.
- **Avoid memory leaks**: Use one CallService/Provider per app; dispose service on logout if needed; never hold BuildContext in async callbacks.
