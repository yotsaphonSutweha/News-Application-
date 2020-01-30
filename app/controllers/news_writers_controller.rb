class NewsWritersController < ApplicationController
  before_action :set_news_writer, only: [:show, :edit, :update, :destroy]

  # GET /news_writers
  # GET /news_writers.json
  def index
    @news_writers = NewsWriter.all
  end

  # GET /news_writers/1
  # GET /news_writers/1.json
  def show
  end

  # GET /news_writers/new
  def new
    @news_writer = NewsWriter.new
  end

  # GET /news_writers/1/edit
  def edit
  end

  # POST /news_writers
  # POST /news_writers.json
  def create
    @news_writer = NewsWriter.new(news_writer_params)

    respond_to do |format|
      if @news_writer.save
        format.html { redirect_to @news_writer, notice: 'News writer was successfully created.' }
        format.json { render :show, status: :created, location: @news_writer }
      else
        format.html { render :new }
        format.json { render json: @news_writer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news_writers/1
  # PATCH/PUT /news_writers/1.json
  def update
    respond_to do |format|
      if @news_writer.update(news_writer_params)
        format.html { redirect_to @news_writer, notice: 'News writer was successfully updated.' }
        format.json { render :show, status: :ok, location: @news_writer }
      else
        format.html { render :edit }
        format.json { render json: @news_writer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news_writers/1
  # DELETE /news_writers/1.json
  def destroy
    @news_writer.destroy
    respond_to do |format|
      format.html { redirect_to news_writers_url, notice: 'News writer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_writer
      @news_writer = NewsWriter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_writer_params
      params.require(:news_writer).permit(:username, :password, :firstName, :secondName, :bio, :role)
    end
end
