require 'rspec-puppet/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'

begin
  if Gem::Specification::find_by_name('puppet-lint')

    # Include Puppet-line
    require 'puppet-lint/tasks/puppet-lint'

    # Disable "more than 80 Chars check"
    PuppetLint.configuration.send('disable_80chars')
    PuppetLint.configuration.send('disable_documentation')
    # Disable check for correct order of parameters in class
    PuppetLint.configuration.send('disable_parameter_order')

    # Exclude spec directory for PuppetLint
    PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "vendor/**/*.pp"]

    # Define Tasks
    task :default => [:validate, :lint, :spec, :beaker]
  end

rescue Gem::LoadError
  task :default => :spec
end
