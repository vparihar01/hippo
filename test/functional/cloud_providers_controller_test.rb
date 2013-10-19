require 'test_helper'

class CloudProvidersControllerTest < ActionController::TestCase
  setup do
    @cloud_provider = cloud_providers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cloud_providers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cloud_provider" do
    assert_difference('CloudProvider.count') do
      post :create, cloud_provider: { key: @cloud_provider.key, name: @cloud_provider.name, provider: @cloud_provider.provider, secret: @cloud_provider.secret }
    end

    assert_redirected_to cloud_provider_path(assigns(:cloud_provider))
  end

  test "should show cloud_provider" do
    get :show, id: @cloud_provider
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cloud_provider
    assert_response :success
  end

  test "should update cloud_provider" do
    put :update, id: @cloud_provider, cloud_provider: { key: @cloud_provider.key, name: @cloud_provider.name, provider: @cloud_provider.provider, secret: @cloud_provider.secret }
    assert_redirected_to cloud_provider_path(assigns(:cloud_provider))
  end

  test "should destroy cloud_provider" do
    assert_difference('CloudProvider.count', -1) do
      delete :destroy, id: @cloud_provider
    end

    assert_redirected_to cloud_providers_path
  end
end
