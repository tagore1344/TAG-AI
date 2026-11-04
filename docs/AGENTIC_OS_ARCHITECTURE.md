# TAG OS — Agentic Operating System Architecture

**Status:** Architecture foundation / audit baseline  
**Target platform:** Windows 11  
**Repository:** `tagore1344/TAG-AI`  
**Working branch:** `agentic-os/architecture-foundation`

## 1. Product direction

TAG OS is an agentic desktop environment built as a controlled orchestration layer over Windows, not a replacement Windows kernel. It should accept text and voice goals, understand desktop context when explicitly permitted, plan work, call narrowly-scoped tools, verify outcomes, retain useful task memory, and report what it did.

The existing TAG-AI application is the foundation. Preserve its working desktop UI, voice pipeline, AI providers, memory components, backend gateway, and Flutter companion while consolidating duplicated execution paths.

## 2. Existing capabilities found in the repository

- Desktop entry points: `run_tag_ai.py`, `assistant_with_brain.py`, `transparent_overlay.py`.
- Voice and wake-word components: Faster-Whisper / speech engine / wake-word modules.
- AI provider and orchestration packages under `ai/`.
- Agent runtime under `core/agent/`: planning, task graphs, task state, policy, judgment, recovery, verification, and runtime coordination.
- Context and memory under `core/context/`.
- OS tool integrations under root controllers and `core/tools/tool_registry.py`.
- FastAPI gateway and confirmation-related services under `backend/`.
- Flutter companion app under `mobile/`.

These components are valuable and should be audited and integrated, not replaced wholesale.

## 3. Target architecture

```text
TAG OS Desktop Shell (PyQt6)
  ├── Command input (text / hotkey / voice)
  ├── Status, plan preview, approvals, activity log
  └── Desktop context (opt-in screen/window observation)
            |
            v
Application Coordinator
  ├── Intent and context resolver
  ├── Agent planner / task graph
  ├── Specialist agents (research, coding, system, files)
  ├── Model router (local-first, cloud fallback by policy)
  └── Task state + bounded execution loop
            |
            v
Policy & Permission Boundary
  ├── Tool allowlist and argument validation
  ├── Risk classification
  ├── Human approval for sensitive actions
  ├── Workspace and path boundaries
  ├── Time / step / resource budgets
  └── Audit log and cancellation
            |
            v
Canonical Tool Runtime
  ├── Windows apps and processes
  ├── File operations
  ├── Browser automation
  ├── Screen capture / UI automation
  ├── System telemetry and settings
  └── Developer tools (Git, tests, terminal)
            |
            v
Verification + Recovery + Memory
  ├── Confirm observable postconditions
  ├── Retry only bounded, safe operations
  ├── Persist task history and user-approved preferences
  └── Never treat model text as proof of success
```

## 4. Engineering principles

1. **Windows-first:** deliver a reliable Windows 11 desktop experience before considering other operating systems.
2. **Local-first inference:** use Ollama where the installed model and hardware are suitable; allow cloud providers only when configured and permitted.
3. **One canonical tool registry:** legacy root-level tools may remain as adapters during migration, but new execution must pass through one policy-enforcing runtime.
4. **Plan, act, observe, verify:** a tool call is not successful merely because it returned without an exception.
5. **Least privilege:** no unrestricted administrator shell, arbitrary command execution, or broad filesystem access for the model.
6. **Human control:** destructive file changes, software installation, sending messages, account actions, privilege changes, shutdown/restart, and external publication require explicit approval.
7. **Bounded autonomy:** cap steps, wall-clock time, tool calls, retries, and resource use. Provide a reliable stop/cancel action.
8. **Traceability:** record goal, plan, tool name, validated arguments, approval decision, result, and verification status. Avoid logging secrets or unnecessary personal data.
9. **Backward compatibility:** preserve existing desktop and mobile experiences while replacing internals incrementally.
10. **No self-modifying production runtime:** agents may propose code changes in an isolated workspace; applying or deploying them requires human review.

## 5. Initial audit findings

The repository already has substantial agent infrastructure. The first milestone is integration and safety hardening, not another parallel framework.

Items requiring targeted tests and fixes:

- There are multiple execution paths: the legacy voice loop, the newer async agent loop, the goal-oriented runtime, and the API gateway. Their permission checks and result semantics must be made consistent.
- The root `tool_registry.py` and `core/tools/tool_registry.py` are separate registries. The latter also contains duplicate `AppController` initialization.
- `PolicyEngine.validate_action()` currently blocks level 0 and HIGH_RISK, but does not itself enforce a confirmation workflow for `CONFIRMATION_REQUIRED`; the end-to-end approval boundary must be verified before autonomous desktop use.
- Autonomy levels 1, 2, 4, and 5 are declared, but the shown policy validation does not give each level distinct behavior. The semantics need to be made explicit and tested.
- The continuous agent loop dispatches tools through the orchestrator; its policy and approval checks need the same enforcement as direct goal execution.
- The fallback path in `AsyncAgentLoop` records a tool result as successful without independently verifying the outcome.
- Legacy desktop code and the backend use different coordinators and registries. We should introduce a shared execution contract and migrate adapters gradually.
- The current README describes an advanced agent runtime, but actual local model and cloud-model capabilities must be tested independently; documentation claims are not runtime verification.

These are audit observations from source inspection. They are not a claim that every path is currently exploitable; each item needs focused tests and review.

## 6. Delivery phases

### Phase 0 — Baseline and safety audit
- Capture branch and test baseline.
- Map all entry points, tool registries, policy checks, and approval flows.
- Add regression tests for policy decisions and execution outcomes.

### Phase 1 — Canonical agent runtime
- Define shared request, plan, action, result, and approval types.
- Route desktop, CLI, and API requests through one coordinator.
- Keep legacy modules as thin adapters until parity is proven.

### Phase 2 — Secure Windows tool layer
- Add typed, allowlisted tools for app launch, system telemetry, file listing/search, and screen capture.
- Implement safe path boundaries and command allowlists.
- Add explicit approvals for sensitive actions.

### Phase 3 — Desktop shell
- Upgrade the PyQt6 overlay into a usable command center with plan preview, action progress, approvals, cancellation, and history.
- Keep the existing voice and wake-word functionality optional and independently switchable.

### Phase 4 — Memory and context
- Unify conversation, task, and project memory behind a single interface.
- Add retention controls and user-visible memory inspection/deletion.

### Phase 5 — Computer use and specialist agents
- Add screen understanding and UI Automation behind permissions.
- Introduce research, coding, testing, and system specialist agents sharing a common task state.

### Phase 6 — Reliability and release
- Build offline tests and mocked tool tests.
- Add Windows integration tests, packaging, crash recovery, and performance checks.
- Enable background autonomy only after policy and cancellation tests pass.

## 7. First implementation milestone (definition of done)

The first code milestone is complete when:

- One shared policy layer decides whether each tool action is allowed, approval-required, or blocked.
- No execution route can bypass that layer.
- Sensitive actions fail closed if approval is unavailable, expired, or mismatched.
- Tool results distinguish execution errors from verified success.
- Each task has a bounded step count and a working cancellation path.
- Tests cover autonomy levels, high-risk actions, approval expiry, invalid arguments, path traversal, and tool failures.
- Existing desktop startup remains functional.

## 8. Current operating mode

Until the first milestone passes, keep TAG OS in supervised mode: read-only inspection and explicitly low-risk actions may run; sensitive or irreversible actions must be approved. Do not enable an always-running autonomous loop by default.
