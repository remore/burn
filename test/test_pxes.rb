require File.expand_path('../helper', __FILE__)

class TestPxes < Test::Unit::TestCase
  include Burn
  include Debug
  require 'ripper'
  require 'pp'
  
  def setup
    Debug::Logger.new.enabled false
  end
  
  def test_command_with_if_command
    assert_equal "if (is_pressed(PAD_RIGHT)){print(123);} ", conv("if is_pressed(:right) then print 123 end")
  end
  
  def test_command_with_if_opassign
    assert_equal "if (is_pressed(PAD_RIGHT)){metaCat.x+=23;} ", conv("if is_pressed(:right) then metaCat.x+=23 end")
  end
  
  def test_simple_assign
    assert_equal "foobar=\"234\";", conv("foobar = \"234\"")
  end
  
  def test_binary
    assert_equal "zoo=234*34*(45/32);", conv("zoo = 234*34*(45/32)")
  end
  
  def test_while_with_varref
    assert_equal "while(TRUE){puts(123,889);}", conv("while true do puts 123, 889 end")
  end
  
  def test_command
    puts conv("wait 100")
    assert_equal "delay(100);", conv("wait 100")
  end
  
  def test_rand
    assert_equal "rand8()", conv("rand")
  end
  
  private
  def conv(code)
    p = Util::Pxes.new(Ripper.sexp(code),Burn::Generator::CSource.new("").get_context,"main")
    pp p.sexp if Debug::Logger.new.enabled?
    p.to_c
  end
end