# frozen_string_literal: true

title 'rubymine archives profile'

control 'rubymine archive' do
  impact 1.0
  title 'should be installed'

  describe file('/etc/default/rubymine.sh') do
    it { should exist }
  end
  # describe file('/usr/local/jetbrains/rubymine-*/bin/rubymine.sh') do
  #    it { should exist }
  # end
  describe file('/usr/share/applications/rubymine.desktop') do
    it { should exist }
  end
end
