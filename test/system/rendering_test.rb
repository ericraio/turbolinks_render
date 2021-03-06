require 'application_system_test_case'

class TurbolinksRenderingTest < ApplicationSystemTestCase
  def setup
    Rails.application.config.turbolinks_render.render_with_turbolinks_by_default = true
  end

  test 'Rendering should be handled by turbolinks when submitting an ajax form with turbolink rendering enabled' do
    create_task_with_title ''
    assert_content "Title can't be blank"
  end

  test 'Rendering should not be handled by turbolinks when submitting an ajax form with turbolink rendering disabled' do
    with_default_option_for_rendering_with_turbolinks(false) do
      create_task_with_title ''
      assert_no_content "Title can't be blank"
    end
  end

  test '500 errors are properly rendered' do
    create_task_with_title 'force error 500'
    assert_content "We're sorry, but something went wrong"
  end

  test '`<script>` elements in responses get executed' do
    create_task_with_title 'force script response'
    assert_selector 'body[data-javascript-was-executed]'
  end

  test 'Empty responses will not be handled by turbolinks (so they will not clear the page)' do
    create_task_with_title 'force empty response'
    assert_content 'New Task'
  end

  def create_task_with_title(title)
    visit new_task_path
    fill_in 'Title', with: title
    click_on 'Create Task'
  end

  def with_default_option_for_rendering_with_turbolinks(value)
    original_value = Rails.application.config.turbolinks_render.render_with_turbolinks_by_default
    Rails.application.config.turbolinks_render.render_with_turbolinks_by_default = value
    yield
  ensure
    Rails.application.config.turbolinks_render.render_with_turbolinks_by_default = original_value
  end
end
