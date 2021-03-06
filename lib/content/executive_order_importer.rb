module Content::ExecutiveOrderImporter
  def self.perform
    executive_orders = []
    FasterCSV.foreach("data/executive_orders.csv", :headers => :first_row) do |line|
      executive_orders << line.to_hash 
    end

    max_known_eo_number = executive_orders.map{|eo| eo['number'] }.max
    Entry.scoped(:conditions => ["executive_order_number <= ?", max_known_eo_number]).update_all(:executive_order_number => nil)
    executive_orders.each do |eo|
      document_number = eo['document_number']
      next if document_number.blank?

      entry = Entry.find_by_document_number(document_number)
      if entry
        entry.update_attributes(
          :executive_order_number => eo['number'],
          :signing_date => eo['signing_date'],
          :granule_class => "PRESDOCU",
          :presidential_document_type_id => 2
        )
      else
        warn "'#{document_number}' not found!"
      end
    end
  end
end
