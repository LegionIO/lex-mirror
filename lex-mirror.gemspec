# frozen_string_literal: true

require_relative 'lib/legion/extensions/mirror/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-mirror'
  spec.version       = Legion::Extensions::Mirror::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Mirror'
  spec.description   = 'Mirror neuron system for brain-modeled agentic AI — automatic behavioral ' \
                       'observation, imitation learning with fidelity tracking, and empathic ' \
                       'resonance from watching other agents act.'
  spec.homepage      = 'https://github.com/LegionIO/lex-mirror'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = 'https://github.com/LegionIO/lex-mirror'
  spec.metadata['documentation_uri']     = 'https://github.com/LegionIO/lex-mirror'
  spec.metadata['changelog_uri']         = 'https://github.com/LegionIO/lex-mirror'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/LegionIO/lex-mirror/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-mirror.gemspec Gemfile]
  end
  spec.require_paths = ['lib']
end
