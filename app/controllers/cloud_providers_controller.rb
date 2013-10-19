class CloudProvidersController < ApplicationController

  # GET /cloud_providers
  # GET /cloud_providers.json
  def index
    @cloud_providers = CloudProvider.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cloud_providers }
    end
  end

  # GET /cloud_providers/1
  # GET /cloud_providers/1.json
  def show
    @cloud_provider = CloudProvider.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cloud_provider }
    end
  end

  # GET /cloud_providers/new
  # GET /cloud_providers/new.json
  def new
    @cloud_provider = CloudProvider.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cloud_provider }
    end
  end

  # GET /cloud_providers/1/edit
  def edit
    @cloud_provider = CloudProvider.find(params[:id])
  end

  # POST /cloud_providers
  # POST /cloud_providers.json
  def create
    puts "#######cloud_provider#####{params[:cloud_provider][:type].inspect}"

    @cloud_provider = params[:cloud_provider][:type].constantize.new(params[:cloud_provider])
    puts "#######cloud_provider#####{@cloud_provider.inspect}"
    puts "#######cloud_provider class #####{@cloud_provider.class}"
    respond_to do |format|
      if @cloud_provider.save
        format.html { redirect_to @cloud_provider, notice: 'Cloud provider was successfully created.' }
        format.json { render json: @cloud_provider, status: :created, location: @cloud_provider }
      else
        format.html { render action: "new" }
        format.json { render json: @cloud_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cloud_providers/1
  # PUT /cloud_providers/1.json
  def update
    @cloud_provider = CloudProvider.find(params[:id])

    respond_to do |format|
      if @cloud_provider.update_attributes(params[:cloud_provider])
        format.html { redirect_to @cloud_provider, notice: 'Cloud provider was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cloud_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cloud_providers/1
  # DELETE /cloud_providers/1.json
  def destroy
    @cloud_provider = CloudProvider.find(params[:id])
    @cloud_provider.destroy

    respond_to do |format|
      format.html { redirect_to cloud_providers_url }
      format.json { head :no_content }
    end
  end
end
