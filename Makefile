.PHONY: update-codex-agents check-codex-agents

update-codex-agents:
	./scripts/update-codex-agents.sh

check-codex-agents:
	./scripts/update-codex-agents.sh --check
