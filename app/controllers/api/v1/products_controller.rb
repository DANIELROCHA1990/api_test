class Api::V1::ProductsController < Api::V1::ApiController
  before_action :set_product, only: %i[show update destroy]
  before_action :require_authorization!, only: %i[show update destroy]

  # GET /products
  def index
    products = current_user.products
    render json: products
  end

  # Get /api/v1/products/id
  # Retorna elemento a partir do id
  def show
    render json: { message: 'Produto Carregado', data: @product }, status: 200
  end

  # Post /api/v1/products
  # Cria um novo elemento a partir do metodo new passando apenas parametros permitidos pelo metodo product_params
  def create
    products = []
    begin
      products_params = JSON.parse(File.read(params[:products]))
      products_params.each do |product_param|
        # Aqui nesta linha, o except manda pro Product new um hash de attributos EXCETO o type
        # Quando o product for criado o user_id fica ligado a ele atraves do merge
        products << Product.new(product_param.except('type').merge(user: current_user))
        # Aqui eu digo pro produto que o product_type e igual ao type de product_params
        products.last.product_type = product_param['type']
        products.last.save
      end
      # Aqui selecionamos os produtos que nao foram salvos
      if products.reject(&:persisted?).empty?
        render json: { message: 'Produto Salvo', data: products }, status: 200
      else
        render json: products.map(&:errors), status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { message: e.message }
    end
  end

  # Delete /api/v1/products/product_id
  # Procura o elemento a partir do id e o deleta atraves do metodo destroy
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    render json: { message: 'Produto Excluido', data: @product }, status: 200
  end

  # Put /api/v1/products/id
  # atualiza o elemento a partir do id aletarando apenas parametros permitidos pelo metodo product_params
  def update
    if @product.update(product_params)
      render json: { message: 'Produto Atualizado', data: @product }, status: 200
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end
end

private

# Passando aqui os parametros permitidos
def product_params
  params.require(:product).permit(:title, :product_type, :description, :filename,
                                  :height, :width, :price, :rating)
end

def set_product
  @product = Product.find(params[:id])
end

# Verifica se product pertence ao current_user
def require_authorization!
  render json: {}, status: 401 unless current_user == @product.user
end
