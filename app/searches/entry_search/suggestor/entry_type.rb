class EntrySearch::Suggestor::EntryType < EntrySearch::Suggestor::Base
  private
  TYPE_NAMES = {
    'rule' => 'RULE',
    'proposed rule' => 'PRORULE',
    'notice' => 'NOTICE',
    'presidential document' => 'PRESDOCU',
    'president' => 'PRESDOCU',
    'presidential' => 'PRESDOCU',
    'executive document' => 'PRESDOCU',
  }
  
  def pattern
    /(#{TYPE_NAMES.keys.map{|n| "(?:^|[^a-zA-Z0-9=-])#{n}\\b"}.join("|")})(?=(?:[^"]*"[^"]*")*[^"]*$)/i
  end
  
  def handle_match(type_name)
    entry_type = TYPE_NAMES[type_name.to_s.downcase]
    if entry_type
      @conditions[:type] = entry_type
    end
  end
end
