require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get translation list with navbar active" do
    get posts_url('translations')
    assert_select('.nav > li > a.active', 'Translation')
  end

  test "should get translation detail with navbar active" do
    get post_url('translations', posts.first.slug)
    assert_select('.nav > li > a.active', 'Translation')
  end

  test "should get blog list with navbar active" do
    get posts_url('blogs')
    assert_select('.nav > li > a.active', 'Blog')
  end

  test "should get blog detail with navbar active" do
    get post_url('blogs', posts.first.slug)
    assert_select('.nav > li > a.active', 'Blog')
  end

  test "should not access pages without `blogs` or `translations`" do
    assert_raises(ActionController::UrlGenerationError) do
      get post_url('books', posts.first.slug)
    end

    assert_raises(ActionController::UrlGenerationError) do
      get posts_url('books')
    end
  end

  test "posts translation page contain title" do
    def test_post_list(num)
      assert_select 'ul.post-list' do
        assert_select 'li.inline-post-wrapper', num
        assert_select 'span.post-meta', num
      end
    end

    get posts_url('translations')
    test_post_list(1)

    get posts_url('blogs')
    test_post_list(2)
  end

  test "post detail page contain title" do
    post = posts.first

    get post_url(post.category.key, post.slug)
    assert_select 'article.post' do
      assert_select 'header.post-header' do
        assert_select 'h1.post-title', post.title
        assert_select 'p.post-meta' do
          assert_select 'time.dt-published', post.created_at.strftime('%A, %Y-%m-%d')
        end
      end

      assert_select 'div.post-content', post.body
    end
  end
end