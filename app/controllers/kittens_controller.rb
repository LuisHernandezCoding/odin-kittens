class KittensController < ApplicationController
  before_action :set_flickr, only: %i[index show new]

  def index
    @kittens = Kitten.all
    respond_to do |format|
      format.html
      format.json { render json: @kittens }
    end
  end

  def show
    @kitten = Kitten.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @kitten }
    end
  end

  def new
    @kitten = Kitten.new
  end

  def edit
    @kitten = Kitten.find(params[:id])
  end

  def create
    @kitten = Kitten.new(kitten_params)

    if @kitten.save
      redirect_to @kitten, notice: 'Kitten was successfully created.'
    else
      render 'new', alert: 'Kitten was not created.'
    end
  end

  def update
    @kitten = Kitten.find(params[:id])

    if @kitten.update(kitten_params)
      redirect_to @kitten, notice: 'Kitten was successfully updated.'
    else
      render 'edit', alert: 'Kitten was not updated.'
    end
  end

  def destroy
    @kitten = Kitten.find(params[:id])
    @kitten.destroy

    redirect_to kittens_path, notice: 'Kitten was successfully destroyed.'
  end

  private

  def kitten_params
    params.require(:kitten).permit(:name, :age, :cuteness, :softness)
  end

  def set_flickr
    p key = ENV.fetch('FLICKR_API_KEY')
    p secret = ENV.fetch('FLICKR_SHARED_SECRET')
    @flickr = Flickr.new(key, secret)
    @photos = @flickr.photos.search(profile: true, user_id: '197231518@N07')
  end
end
