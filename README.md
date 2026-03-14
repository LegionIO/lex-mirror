# lex-mirror

Mirror neuron system simulation for LegionIO agents. Part of the LegionIO cognitive architecture extension ecosystem (LEX).

## What It Does

`lex-mirror` implements observational learning via mirror system simulation. The agent observes behaviors from other agents, builds resonance models via EMA, and can imitate those behaviors with configurable fidelity. Repeated observations of the same agent or action increase resonance through familiarity and repetition boosts. Imitation outcomes improve fidelity over time.

Key capabilities:

- **Behavioral observation**: record actions observed from other agents
- **Resonance EMA**: familiarity boost (+0.2) and repetition boost (+0.1) on repeated observations
- **Imitation**: reproduce an observed behavior with per-agent+action fidelity tracking
- **Fidelity learning**: imitation outcomes adjust fidelity (+/-0.05 per outcome)
- **Cross-agent repertoire**: behavioral library across all observed agents and domains

## Installation

Add to your Gemfile:

```ruby
gem 'lex-mirror'
```

Or install directly:

```
gem install lex-mirror
```

## Usage

```ruby
require 'legion/extensions/mirror'

client = Legion::Extensions::Mirror::Client.new

# Observe another agent's behavior
client.observe_behavior(agent_id: 'agent-expert', action: :code_review, domain: :engineering)
client.observe_behavior(agent_id: 'agent-expert', action: :code_review, domain: :engineering)
# Repetition boost applied on second observation

# Imitate the behavior
result = client.imitate_behavior(agent_id: 'agent-expert', action: :code_review, context: { pr_id: 42 })
# => { agent_id: 'agent-expert', action: :code_review, fidelity: 0.7, imitation_id: "..." }

# Report outcome to improve fidelity
client.report_imitation_outcome(agent_id: 'agent-expert', action: :code_review, success: true)

# Find strongest mirrors
client.strongest_mirrors(limit: 5)

# All observations in a domain
client.observations_in(domain: :engineering)

# Full repertoire
client.repertoire_status
```

## Runner Methods

| Method | Description |
|---|---|
| `observe_behavior` | Record an observed behavior from another agent |
| `imitate_behavior` | Reproduce an observed behavior |
| `report_imitation_outcome` | Update fidelity based on imitation outcome |
| `strongest_mirrors` | Top N agent+action pairs by resonance |
| `observations_for` | All observations for a specific agent |
| `observations_in` | All observations in a domain across agents |
| `repertoire_status` | Full behavioral repertoire with resonance labels |
| `update_mirror` | Decay resonance values (also runs automatically via actor) |
| `mirror_stats` | Agent count, observation count, avg resonance |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
