require File.expand_path('../helper', __FILE__)

class TestBurn < Test::Unit::TestCase
  include Burn

  def test_load
    builder = Builder.new('./')
    assert_equal Fixnum, builder.load(<<-EOS).index("put_str(NTADR(0,1),\"HELLO!\");").class
scene do
  label "hello!"
end
EOS
  end
end