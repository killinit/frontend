class DebtTestController < EmbeddedToolsController
  def parent_template
    'layouts/engine_unconstrained'
  end

  protected
    def category_id
      ''
    end
end
