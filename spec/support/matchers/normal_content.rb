RSpec::Matchers.define :have_normal_content do |expected|
  match do |actual|
    actual.text.squish =~ Regexp.new(expected)
  end

  failure_message_for_should do |actual|
    "expected content '#{expected}' in normalized text '#{actual.text.squish}'"
  end

  failure_message_for_should_not do |actual|
    "expected not to find content '#{expected}' in normalized text '#{actual.text.squish}'"
  end
end
