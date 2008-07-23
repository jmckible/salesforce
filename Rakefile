require 'spec/rake/spectask'

task :default => :spec

desc 'Run all non-live specs'
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/*spec.rb']
end

desc 'Run live specs'
Spec::Rake::SpecTask.new('spec:live') do |t|
  t.spec_files = FileList['spec/live/*spec.rb']
end

desc 'Run all specs'
Spec::Rake::SpecTask.new('spec:all') do |t|
  t.spec_files = FileList['spec/*spec.rb'] + FileList['spec/live/*spec.rb']
end