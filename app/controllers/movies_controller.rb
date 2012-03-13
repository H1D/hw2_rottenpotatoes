class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.select(:rating).collect {|m| m.rating}.uniq
    do_redirect = false
    
    if params.include? :order
      @hilite = params[:order]
    elsif session.include? :movie_order
      do_redirect = true
      @hilite = session[:movie_order]
    end

    if params.include? :ratings
      @checked_ratings = params[:ratings]
    elsif session.include? :movie_checked_ratings
      do_redirect = true
      @checked_ratings = session[:movie_checked_ratings]
    elsif not defined? @checked_ratings
      @checked_ratings = {}
    end

    @movies = Movie.order(@hilite)
    if @checked_ratings.length > 0
      @movies = @movies.where(:rating => @checked_ratings.keys)
    end

    session[:movie_order] = @hilite
    session[:movie_checked_ratings] = @checked_ratings

    if do_redirect == true
      redirect_to movies_path({:order => @hilite,:ratings => @checked_ratings})
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
