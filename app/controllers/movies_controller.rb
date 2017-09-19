class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings] != nil
      session[:ratings] = params[:ratings]
    end
    if params[:sort] != nil
      session[:sort] = params[:sort]
    end
    if session[:ratings] == nil
      @movies = Movie.order(session[:sort])
    else
      @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
    end
    if session[:sort] == "title"
      @hilite_title = 'hilite'
    elsif session[:sort] == "release_date"
      @hilite_release_date = 'hilite'
    else
      @hilite_title = ''
      @hilite_release_date = ''
    end
    @all_ratings = Movie.get_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
