#!/usr/bin/env ruby

require 'minitest/autorun'

class PhotoAlbumTest < Minitest::Test
  def test_photo_album_setup
    photo_album = PhotoAlbum.new('x', 'y')
    assert photo_album.base_album_url = 'x'
    assert photo_album.album_param = 'y'
  end

  def test_build_url_with_param
    photo_album = PhotoAlbum.new('url', 'param')
    assert photo_album.build_url(1) == URI('url?param=1')
  end

  def test_build_url_without_param
    photo_album = PhotoAlbum.new('url')
    assert photo_album.build_url(1) == URI('url')
  end

  def test_get_response
    mock = Minitest::Mock.new
    mock.expect :get, "success"
    photo_album = PhotoAlbum.new('url')

    Net::HTTP.stub :get, mock do
      assert photo_album.get_response(URI('url')), 'success'
    end
  end
end

require 'uri'
require 'net/http'

class PhotoAlbum
  attr_accessor :base_album_url, :album_param

  def initialize(url, query_param_key=nil)
    @base_album_url = url
    @album_param = query_param_key
  end

  def retrieve(album_id)
    uri = build_url(album_id)
    response = get_response(uri)
    return response
  end

  def build_url(album_id=nil)
    uri = URI(base_album_url)
    uri.query = "#{album_param}=#{album_id}" if album_param && album_id
    return uri
  end

  def get_response(uri)
    Net::HTTP.get(uri)
  end
end

photo_album = PhotoAlbum.new('https://jsonplaceholder.typicode.com/photos', 'albumId')

photo_album.retrieve(ARGV[0])