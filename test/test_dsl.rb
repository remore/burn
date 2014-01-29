require File.expand_path('../helper', __FILE__)

class TestDsl < Test::Unit::TestCase
  include Burn
  include Debug
  
  def setup
    Debug::Logger.new.enabled false
    @game_generator = Generator::CSource.new(self)
  end
  
  def test_scene_fade_in
    Dsl::Scene.new(nil, @game_generator.get_context).instance_eval "fade_in"
    assert_equal "screen_fade_in();", @game_generator.code_blocks[1]
  end
  
  def test_delay
    Dsl::Scene.new(nil, @game_generator.get_context).instance_eval "wait 100"
    assert_equal "delay(100);", @game_generator.code_blocks.join
  end
  
end