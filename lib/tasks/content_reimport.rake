namespace :content do
  namespace :entries do
    desc "Reimport entry data from FDSys"
    task :reimport => :environment do
      Content.parse_dates(ENV['DATE']).each do |date|
        Resque.enqueue(EntryReimporter, date,
                       :except => [:checked_regulationsdotgov_at, :regulationsdotgov_url, :comment_url],
                       :force_reload_mods => true,
                       :force_reload_bulkdata => true)
      end
    end

    desc "Recompile pre-compiled Entry pages"
    task :recompile => :environment do
      Content.parse_dates(ENV['DATE']).each do |date|
        Resque.enqueue(EntryRecompiler, :abstract, date)
        Resque.enqueue(EntryRecompiler, :full_text, date)
      end
    end

    namespace :presidential_documents do
      desc "Reimport presidential documents"
      task :reimport => :environment do
        Entry.scoped(:conditions => "granule_class = 'PRESDOCU' AND publication_date > '2000-01-01'").find_each do |entry|
          puts "reimporting #{entry.document_number} (#{entry.publication_date})"
          next unless File.exists?(entry.full_xml_file_path)
          bulkdata_node = Nokogiri::XML(open(entry.full_xml_file_path)).root
          Content::EntryImporter.new(:entry => entry, :bulkdata_node => bulkdata_node).update_attributes(:presidential_document_type_id, :signing_date, :executive_order_number)
        end
      end
    end
  end
end
