module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def respone_record_serializer(object, model = ActsAsBookable::BookingSerializer, status = :ok)
    render json: {
        data: model.new(object)
      }, status: status
  end

  def respone_collection_serializer(objects, page, total, model = ActsAsBookable::BookingSerializer)
    limit_value = objects.limit_value

    render json: {
        data:
          ActiveModel::Serializer::CollectionSerializer.new(
            objects, each_serializer: model
          ).as_json,
        metadata: {
          page: page,
          per_page: limit_value,
          total: total,
          total_page: (total.to_f / limit_value).ceil
        }}, status: 200
  end

end
