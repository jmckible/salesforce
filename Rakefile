require 'spec/rake/spectask'

task :default => :spec

desc 'Run all specs'
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/*spec.rb']
end