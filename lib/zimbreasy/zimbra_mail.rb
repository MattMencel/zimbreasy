module Zimbreasy
  module Mail
  
    def get_appt_summaries(auth)
     client = Savon::Client.new
        
      client.config.pretty_print_xml = true
      client.config.log = false

      namespaces = {
        "xmlns:soap" => "http://schemas.xmlsoap.org/soap/envelope/", #used to be soapenv not soap
        "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema"
      }
      mini_namespaces = {
        "xmlns="=>"urn:zimbraAccount"
      }
      response = client.request "CreateAppointmentRequest"  do
        http.headers = { "Content-Length" => "0", "Connection" => "Keep-Alive" }
        client.http.headers["SOAPAction"] =  "http://schema.microbilt.com/messages/GetReport"

        soap.xml do |xml|
          xml.soap(:Envelope, namespaces) do |xml|
            xml.soap(:Header) do |xml|
              xml.context(mini_namespaces) do |xml|
                xml.authToken(auth[:auth_token])
              end
            end

            xml.soap(:Body) do |xml|
              xml.GetAppointmentSummariesRequest({"s" => 0, "e" => Time.now.to_i*1000})
            end
          end
        end
      end
    end
  end
end
