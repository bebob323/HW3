require "spec_helper"
require_relative "../app/controllers/movies_controller"
require_relative "../app/models/movie"
require_relative "../config/routes"

describe Movie, :type => :model do
  let!(:transformers) { 
      Movie.create(
          :title => "Transformers", 
          :release_date => '2007-07-03 [00:00:00]', 
          :rating => 'PG-13', 
          :director => "Michael Bay") }
  let!(:nemo) { 
      Movie.create(
          :title => "Finding Nemo", 
          :rating => 'G', 
          :release_date => '2003-05-30 [00:00:00]', 
          :director => "Andrew Stanton") }
  let!(:clockwork_orange) {
      Movie.create(
          :title => "A Clockwork Orange", 
          :rating => 'X', 
          :release_date => '1972-02-02 [00:00:00]', 
          :director => "Stanley Kubrick") }
  let!(:space_odyssey) {
      Movie.create(
          :title => "2001: A Space Odyssey", 
          :rating => 'G', 
          :release_date => '1968-04-03 [00:00:00]', 
          :director => "Stanley Kubrick") }
  let!(:no_director) {
      Movie.create(
          :title => "Empty", 
          :rating => 'G', 
          :release_date => '1995-06-19 [00:00:00]', 
          :director => nil) }
  describe 'director' do
    it 'match' do
      dir1 = Movie.find_all_by_director("Stanley Kubrick")
      dir2 = Movie.match_director("Stanley Kubrick")
      expect(dir1).to eq(dir2)
    end
  end
end

describe MoviesController, :type => :controller do
  let!(:transformers) { 
      Movie.create(
          :title => "Transformers", 
          :release_date => '2007-07-03 [00:00:00]', 
          :rating => 'PG-13', 
          :director => "Michael Bay") }
  let!(:nemo) { 
      Movie.create(
          :title => "Finding Nemo", 
          :rating => 'G', 
          :release_date => '2003-05-30 [00:00:00]', 
          :director => "Andrew Stanton") }
  let!(:clockwork_orange) {
      Movie.create(
          :title => "A Clockwork Orange", 
          :rating => 'X', 
          :release_date => '1972-02-02 [00:00:00]', 
          :director => "Stanley Kubrick") }
  let!(:space_odyssey) {
      Movie.create(
          :title => "2001: A Space Odyssey", 
          :rating => 'G', 
          :release_date => '1968-04-03 [00:00:00]', 
          :director => "Stanley Kubrick") }
  let!(:no_director) {
      Movie.create(
          :title => "Empty", 
          :rating => 'G', 
          :release_date => '1995-06-19 [00:00:00]', 
          :director => nil) }
          
  describe 'directors controller' do
    it 'redirection' do
      movie = assigns(:movie)
      get :directors, :id => movie.object_id
      movie = assigns(:movie)
      movies = assigns(:movies)
      if movie.director == nil or  movie.director == ""
        expect(movies).to eq(nil)
      else
        movies.each { |m| expect(m.director).to eq(movie.director)}
      end
    end
  end
  
  describe 'index controller' do
    it 'sorting by date' do
      get :index, :sort => 'release_date'
      get :index, :sort => 'release_date'
      header = assigns(:date_header)
      expect(header).to eq("hilite")
      all = assigns(:movies)
      expect(all).to eq(all.sort! { |x,y| x.title <=> y.title })
    end  
    it 'sorting by title' do
      get :index, :sort => 'title'
      get :index, :sort => 'title'
      header = assigns(:title_header)
      expect(header).to eq("hilite")
      all = assigns(:movies)
      expect(all).to eq(all.sort! { |x,y| x.title <=> y.title })
    end
  end
  
  describe 'edit controller' do
    it 'verify' do
      get :edit, :id => '1'
      movie = assigns(:movie)
      expect(movie.id).to eq(1)
    end  
  end
  
  describe 'destroy controller' do
    it 'verify' do
      get :destroy, :id => '1'
      expect(Movie.find_by_title("Transformers")).to eq(nil)
    end  
  end
  
  describe 'create controller' do
    it 'verify' do
      get :create, :movie => {:title => "Transformers", :release_date => "2007-07-03 [00:00:00]", :rating => "PG-13", :director => "Michael Bay"}
      movie = assigns(:movie)
      expect(movie.title).to eq('Transformers')
    end  
  end
end

describe 'routing test', :type => :routing do
  it 'directors' do
    srand 5768
    id =rand(1..4)
    expect(get("movies/#{id}/directors")).to route_to("movies#directors", :id => id.to_s)
  end
end