module Lokka
  class App
    get '/admin/snippets' do
      @snippets = Snippet.order('created_at DESC').
        page(params[:page]).
        per(settings.admin_per_page)
      haml :'admin/snippets/index', layout: :'admin/layout'
    end

    get '/admin/snippets/new' do
      @snippet = Snippet.new
      haml :'admin/snippets/new', layout: :'admin/layout'
    end

    post '/admin/snippets' do
      @snippet = Snippet.new(params[:snippet])
      if @snippet.save
        flash[:notice] = t('snippet_was_successfully_created')
        redirect to("/admin/snippets/#{@snippet.id}/edit")
      else
        haml :'admin/snippets/new', layout: :'admin/layout'
      end
    end

    get '/admin/snippets/:id/edit' do |id|
      @snippet = Snippet.where(id: id).first or raise Sinatra::NotFound
      haml :'admin/snippets/edit', layout: :'admin/layout'
    end

    put '/admin/snippets/:id' do |id|
      @snippet = Snippet.where(id: id).first or raise Sinatra::NotFound
      if @snippet.update_attributes(params['snippet'])
        flash[:notice] = t('snippet_was_successfully_updated')
        redirect to("/admin/snippets/#{@snippet.id}/edit")
      else
        haml :'admin/snippets/edit', layout: :'admin/layout'
      end
    end

    delete '/admin/snippets/:id' do |id|
      snippet = Snippet.where(id: id).first or raise Sinatra::NotFound
      snippet.destroy
      flash[:notice] = t('snippet_was_successfully_deleted')
      redirect to('/admin/snippets')
    end
  end
end
