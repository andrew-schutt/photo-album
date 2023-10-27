#!/usr/bin/env ruby

require 'minitest/autorun'

class PhotoAlbumTest < Minitest::Test
  def test_photo_album_setup
    photo_album = PhotoAlbum.new('x', 'y')
    assert photo_album.base_album_url == 'x'
    assert photo_album.album_param == 'y'
  end

  def test_build_url_method_with_param
    photo_album = PhotoAlbum.new('url', 'param')
    assert photo_album.build_url(1) == URI('url?param=1')
  end

  def test_build_url_method_without_param
    photo_album = PhotoAlbum.new('url')
    assert photo_album.build_url(1) == URI('url')
  end

  def test_get_response_method
    mock = Minitest::Mock.new
    mock.expect :get, "success"
    photo_album = PhotoAlbum.new('url')

    Net::HTTP.stub :get, mock do
      assert photo_album.get_response(URI('url')), 'success'
    end
  end

  def test_parse_photo_album_method
    photo_album = PhotoAlbum.new('url')
    raw_json = "[\n {\n \"albumId\": 1,\n \"id\": 1,\n \"title\": \"awesome title\",\n \"url\": \"https://via.placeholder.com/600/92c952\",\n \"thumbnailUrl\": \"https://via.placeholder.com/150/92c952\"\n}]"
    assert photo_album.parse_photo_album(raw_json, photo_album.build_filter_lambda(nil, nil)) == [{:id=>1, :title=>"awesome title"}]
  end

  def test_print_photos_method
    photo_album = PhotoAlbum.new('url')
    parsed_album = [{:id=>1, :title=>"awesome title"}]
    assert_output("[1] awesome title\n") { photo_album.print_photos(parsed_album) }
  end

  def test_print_photos_method_empty_photos
    photo_album = PhotoAlbum.new('url')
    parsed_album = []
    assert_output("Hmmm... no albums with that id :(\n") { photo_album.print_photos(parsed_album) }
  end

  def test_filter_lambda_filters_with_params
    photo_album = PhotoAlbum.new('url')
    filter_lambda = photo_album.build_filter_lambda('id', 1)
    raw_json = "[\n {\n \"albumId\": 1,\n \"id\": 1,\n \"title\": \"awesome title\",\n \"url\": \"https://via.placeholder.com/600/92c952\",\n \"thumbnailUrl\": \"https://via.placeholder.com/150/92c952\"\n}, {\n \"albumId\": 1,\n \"id\": 2,\n \"title\": \"super title\",\n \"url\": \"https://via.placeholder.com/600/94c952\",\n \"thumbnailUrl\": \"https://via.placeholder.com/150/94c952\"\n}]"
    json_hash = JSON.parse(raw_json)
    assert json_hash.filter { |val| filter_lambda.call(val) }.size == 1
  end

  def test_filter_lambda_does_not_filter_without_params
    photo_album = PhotoAlbum.new('url')
    filter_lambda = photo_album.build_filter_lambda(nil, nil)
    raw_json = "[\n {\n \"albumId\": 1,\n \"id\": 1,\n \"title\": \"awesome title\",\n \"url\": \"https://via.placeholder.com/600/92c952\",\n \"thumbnailUrl\": \"https://via.placeholder.com/150/92c952\"\n}, {\n \"albumId\": 1,\n \"id\": 2,\n \"title\": \"super title\",\n \"url\": \"https://via.placeholder.com/600/94c952\",\n \"thumbnailUrl\": \"https://via.placeholder.com/150/94c952\"\n}]"
    json_hash = JSON.parse(raw_json)
    assert json_hash.filter { |val| filter_lambda.call(val) } == json_hash
  end

  def test_filter_lambda_with_invalid_params
    photo_album = PhotoAlbum.new('url')
    filter_lambda = photo_album.build_filter_lambda('doesnt', 'exist')
    raw_json = "[\n {\n \"albumId\": 1,\n \"id\": 1,\n \"title\": \"awesome title\",\n \"url\": \"https://via.placeholder.com/600/92c952\",\n \"thumbnailUrl\": \"https://via.placeholder.com/150/92c952\"\n}, {\n \"albumId\": 1,\n \"id\": 2,\n \"title\": \"super title\",\n \"url\": \"https://via.placeholder.com/600/94c952\",\n \"thumbnailUrl\": \"https://via.placeholder.com/150/94c952\"\n}]"
    json_hash = JSON.parse(raw_json)
    assert json_hash.filter { |val| filter_lambda.call(val) }.size == 0
  end

  def test_print_message_when_no_filters_params_given
    photo_album = PhotoAlbum.new('url')
    assert_output("No additional filtering provided (you can filter an album by any fields on the photo)\n") { photo_album.build_filter_lambda(nil, nil) }
  end
end

require 'uri'
require 'net/http'
require 'json'

class PhotoAlbum
  attr_accessor :base_album_url, :album_param

  def initialize(url, query_param_key=nil)
    @base_album_url = url
    @album_param = query_param_key
  end

  def retrieve(album_id, filter_by, filter_val)
    response = get_response(build_url(album_id))
    filter_lambda = build_filter_lambda(filter_by, filter_val)
    print_photos(parse_photo_album(response, filter_lambda))
  end

  def build_url(album_id=nil)
    uri = URI(base_album_url)
    uri.query = "#{album_param}=#{album_id}" if album_param && album_id
    return uri
  end

  def get_response(uri)
    Net::HTTP.get(uri)
  end

  def parse_photo_album(raw_response, filter_lambda)
    json_hash = JSON.parse(raw_response)
    json_hash.filter { |photo| filter_lambda.call(photo) }.map{ |photo| {id: photo['id'], title: photo['title']} }
  end

  def print_photos(photos)
    if photos.empty?
      puts "Hmmm... no albums with that id :("
    else
      photos.each{ |photo| puts "[#{photo[:id]}] #{photo[:title]}" }
    end
  end

  def build_filter_lambda(filter_by, filter_val)
    if filter_by.nil? || filter_val.nil?
      puts "No additional filtering provided (you can filter an album by any fields on the photo)"
      ->(photo) { photo }
    else
      ->(photo) { photo[filter_by].to_s == filter_val.to_s }
    end
  end
end

photo_album = PhotoAlbum.new('https://jsonplaceholder.typicode.com/photos', 'albumId')

photo_album.retrieve(ARGV[0], ARGV[1], ARGV[2])
