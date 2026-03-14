# lex-mirror

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-mirror`
- **Version**: `0.1.0`
- **Namespace**: `Legion::Extensions::Mirror`

## Purpose

Mirror neuron system simulation for LegionIO agents. Observes other agents' behaviors, builds per-agent resonance models via EMA, and enables imitation of observed behaviors with configurable fidelity. Tracks imitation outcomes to improve fidelity over time. Provides a behavioral repertoire of all observed behaviors across agents and domains for social learning.

## Gem Info

- **Require path**: `legion/extensions/mirror`
- **Ruby**: >= 3.4
- **License**: MIT
- **Registers with**: `Legion::Extensions::Core`

## File Structure

```
lib/legion/extensions/mirror/
  version.rb
  helpers/
    constants.rb            # EMA alpha, resonance limits, fidelity params, labels
    observed_behavior.rb    # ObservedBehavior value object
    mirror_system.rb        # MirrorSystem registry + resonance + imitation
  actors/
    decay.rb                # Resonance decay actor
  runners/
    mirror.rb               # Runner module

spec/
  legion/extensions/mirror/
    helpers/
      constants_spec.rb
      observed_behavior_spec.rb
      mirror_system_spec.rb
    actors/decay_spec.rb
    runners/mirror_spec.rb
  spec_helper.rb
```

## Key Constants

```ruby
MAX_OBSERVATIONS       = 200   # per-agent observation cap
MAX_IMITATIONS         = 50    # imitation record cap
MIRROR_ALPHA           = 0.15  # EMA factor for resonance updates
DEFAULT_RESONANCE      = 0.3   # starting resonance for new agent
RESONANCE_FLOOR        = 0.05
RESONANCE_DECAY        = 0.01  # per decay tick
FAMILIARITY_BOOST      = 0.2   # resonance boost when same agent seen again
REPETITION_BOOST       = 0.1   # resonance boost when same action observed again
DEFAULT_FIDELITY       = 0.7   # starting imitation fidelity
FIDELITY_LEARNING_RATE = 0.05  # fidelity adjustment per imitation outcome
MAX_MIRRORED_AGENTS    = 20
MAX_REPERTOIRE         = 100   # total cross-agent behavior repertoire cap

RESONANCE_LABELS = {
  (0.7..)     => :strong,
  (0.4...0.7) => :moderate,
  (0.2...0.4) => :weak,
  (..0.2)     => :fading
}
```

## Helpers

### `Helpers::ObservedBehavior` (class)

A single observed behavior from another agent.

| Attribute | Type | Description |
|---|---|---|
| `id` | String (UUID) | unique identifier |
| `agent_id` | String | the observed agent |
| `action` | Symbol | the observed action |
| `domain` | Symbol | subject domain |
| `resonance` | Float (0..1) | current resonance strength (EMA-updated) |
| `observation_count` | Integer | times this behavior has been observed |

### `Helpers::MirrorSystem` (class)

Central registry for all observations and imitation fidelity models.

| Method | Description |
|---|---|
| `observe(agent_id:, action:, domain:)` | records observation; applies FAMILIARITY_BOOST if agent known, REPETITION_BOOST if action repeated; EMA-updates resonance |
| `imitate(agent_id:, action:, context:)` | creates imitation record from observed behavior |
| `update_fidelity(agent_id:, action:, success:)` | adjusts fidelity for agent+action pair |
| `strongest_mirrors(limit:)` | top N agent+action pairs by resonance |
| `observations_for_agent(agent_id:)` | all observations for a specific agent |
| `observations_in_domain(domain:)` | all observations in a domain across agents |
| `decay_all` | decrements resonance by RESONANCE_DECAY; removes below RESONANCE_FLOOR |

## Actors

**`Actors::Decay`** — fires periodically, calls `update_mirror` on the runner to decay all resonance values.

## Runners

Module: `Legion::Extensions::Mirror::Runners::Mirror`

Private state: `@system` (memoized `MirrorSystem` instance).

| Runner Method | Parameters | Description |
|---|---|---|
| `observe_behavior` | `agent_id:, action:, domain:` | Record an observed behavior |
| `imitate_behavior` | `agent_id:, action:, context: {}` | Imitate an observed behavior |
| `report_imitation_outcome` | `agent_id:, action:, success:` | Update fidelity based on outcome |
| `strongest_mirrors` | `limit: 10` | Top N agent+action pairs by resonance |
| `observations_for` | `agent_id:` | All observations for an agent |
| `observations_in` | `domain:` | All observations in a domain |
| `repertoire_status` | (none) | Full behavioral repertoire with resonance labels |
| `update_mirror` | (none) | Decay cycle (called by actor) |
| `mirror_stats` | (none) | Agent count, observation count, avg resonance, fidelity |

## Integration Points

- **lex-mesh**: agent_ids from mesh-connected peers are the natural keys for observation. Mirror system models behaviors observed via mesh messages.
- **lex-joint-attention**: shared attention targets provide context for which agent behaviors are worth observing and mirroring.
- **lex-trust**: high-trust agents should receive higher initial resonance (caller responsibility to set resonance via observe calls weighted by trust).
- **lex-social**: social relationship modeling provides the substrate for who to mirror; resonance strength reflects relationship quality.
- **lex-metacognition**: `Mirror` is listed under `:communication` capability category.

## Development Notes

- Resonance is per-agent (one resonance score per observed agent, EMA-updated on each observation). Multiple behaviors from the same agent all update the same resonance score.
- `FAMILIARITY_BOOST` applies when an agent_id is already in the observation registry. `REPETITION_BOOST` applies when the same action has been observed before from this agent. Both can apply simultaneously.
- Fidelity is per-agent+action pair, not global. Initial fidelity is DEFAULT_FIDELITY (0.7). Successful imitations increase by FIDELITY_LEARNING_RATE; failures decrease by the same amount.
- MAX_MIRRORED_AGENTS and MAX_OBSERVATIONS are enforced by removing lowest-resonance entries when limits are exceeded.
- `observations_in_domain` returns observations from all agents, not filtered by agent. This is the cross-agent behavioral repertoire for a domain.
- Decay removes observations at RESONANCE_FLOOR (0.05). An agent with all observations below floor is removed from the system entirely.
