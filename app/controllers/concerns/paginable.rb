module Paginable
  protected
    def _to_i(param, default_no = 1)
      param && param&.to_i > 0 ? param&.to_i : default_no.to_i
    end

    # def set_page
    #   @page      = _to_i(params[:page], 1)
    #   @page      = set_per_page * (@page - 1)
    # end

    # def set_per_page
    #   @per_page  = _to_i(params[:per_page], 10)
    # end

    def current_page
      _to_i(params[:page], 1)
    end

    def per_page
      _to_i(params[:per_page], 10)
    end

    def get_links_serializer_options links_paths, collection 
      {
        links: {
          first: send(links_paths, page: 1),
          last: send(links_paths, page: collection.total_pages),
          prev: send(links_paths, page: collection.previous_page),
          next: send(links_paths, page: collection.next_page),
        }
      }
    end
end