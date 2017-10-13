module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def respone_record_serializer(object, model = BookingSerializer, status = :ok)
    render json: {
        data: model.new(object)
      }, status: status
  end

  def respone_collection_serializer(objects, limit, offset, total, model = BookingSerializer)

    render json: {
        data:
          ActiveModel::Serializer::CollectionSerializer.new(
            objects, each_serializer: model
          ).as_json,
        metadata: {
          limit: limit,
          offset: offset,
          total: total,
        }}, status: 200
  end

end
