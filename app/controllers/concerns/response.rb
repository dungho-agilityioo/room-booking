module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def report_response(objects, page, limit_value, total)
    render json: {
        data:
          ActiveModel::Serializer::CollectionSerializer.new(
            objects, each_serializer: ActsAsBookable::BookingSerializer
          ).as_json,
        metadata: {
          page: page,
          per_page: limit_value,
          total: total,
          total_page: (total.to_f / limit_value).ceil
        }}, status: 200
  end
end
