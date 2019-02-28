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
    @movies = Movie.all
    
    @sort = params[:sort] || session[:sort]
    @ratings = params[:ratings] || session[:ratings]
    @all_ratings = Movie.rating
    
    if(@sort)
        session[:sort] = @sort
        @movies = Movie.order(@sort.to_sym)
    end
    
    if(@ratings)
    session[:ratings] = @ratings
        @movies = Movie.where(rating: @ratings.keys)
    end
    
    if(params[:sort] != session[:sort] or params[:ratings] != session[:ratings])
        session[:sort] = @sort
        session[:ratings] = @ratings
        redirect_to(sort: @sort, rating: @ratings) and return
    end
    
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
