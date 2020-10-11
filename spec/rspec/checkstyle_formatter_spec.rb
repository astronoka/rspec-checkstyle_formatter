# frozen_string_literal: true

RSpec.describe RSpec::CheckstyleFormatter do
  let(:formatter) { described_class.new(output) }
  let(:output) { StringIO.new }

  context 'with no failed notification' do
    before do
      formatter.close(RSpec::Core::Notifications::NullNotification)
    end

    it 'outputs XML declaration and empty checkstyle element' do
      expect(output.string).to eq "<?xml version='1.0'?>\n<checkstyle/>"
    end
  end

  context 'with failed notifications' do
    let(:notification1) do
      ex = double(RSpec::Core::Example)
      allow(ex).to receive(:file_path).and_return('./spec/request/a.rb')
      allow(ex).to receive(:location).and_return('./spec/request/a.rb:1')

      noti = double(RSpec::Core::Notifications::FailedExampleNotification)
      allow(noti).to receive(:example).and_return(ex)
      allow(noti).to receive(:description).and_return('description1')
      allow(noti).to receive(:message_lines).and_return(%w[ML1 ML2 ML3])
      allow(noti).to receive(:formatted_backtrace).and_return(%w[bt1 bt2])

      noti
    end
    let(:notification2_1) do
      ex = double(RSpec::Core::Example)
      allow(ex).to receive(:file_path).and_return('./spec/request/b.rb')
      allow(ex).to receive(:location).and_return('./spec/request/b.rb:2')

      noti = double(RSpec::Core::Notifications::FailedExampleNotification)
      allow(noti).to receive(:example).and_return(ex)
      allow(noti).to receive(:description).and_return('description2-1')
      allow(noti).to receive(:message_lines).and_return(%w[ML1 ML2])
      allow(noti).to receive(:formatted_backtrace).and_return(%w[bt1 bt2 bt3])

      noti
    end
    let(:notification2_2) do
      ex = double(RSpec::Core::Example)
      allow(ex).to receive(:file_path).and_return('./spec/request/b.rb')
      allow(ex).to receive(:location).and_return('./spec/request/b.rb:16')

      noti = double(RSpec::Core::Notifications::FailedExampleNotification)
      allow(noti).to receive(:example).and_return(ex)
      allow(noti).to receive(:description).and_return('description2-2')
      allow(noti).to receive(:message_lines).and_return(%w[ML1 ML2])
      allow(noti).to receive(:formatted_backtrace).and_return(%w[bt1 bt2])

      noti
    end

    before do
      formatter.example_failed(notification1)
      formatter.example_failed(notification2_1)
      formatter.example_failed(notification2_2)
      formatter.close(RSpec::Core::Notifications::NullNotification)
    end

    it 'outputs valid XML' do
      expect(output.string).to eq <<~XML.chomp
        <?xml version='1.0'?>
        <checkstyle>
          <file name='./spec/request/a.rb'>
            <error line='1' column='1' severity='error' message='ML1\nML2\nML3\n\nbt1\nbt2' source='description1'/>
          </file>
          <file name='./spec/request/b.rb'>
            <error line='2' column='1' severity='error' message='ML1\nML2\n\nbt1\nbt2\nbt3' source='description2-1'/>
            <error line='16' column='1' severity='error' message='ML1\nML2\n\nbt1\nbt2' source='description2-2'/>
          </file>
        </checkstyle>
      XML
    end
  end
end
