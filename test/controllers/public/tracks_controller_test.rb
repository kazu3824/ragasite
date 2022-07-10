require "test_helper"

class Public::TracksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_tracks_index_url
    assert_response :success
  end

  test "should get show" do
    get public_tracks_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_tracks_edit_url
    assert_response :success
  end
end
