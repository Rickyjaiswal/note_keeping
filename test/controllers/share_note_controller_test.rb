require "test_helper"

class ShareNoteControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get share_note_index_url
    assert_response :success
  end
end
