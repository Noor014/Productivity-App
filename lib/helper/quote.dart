class Quote{
  final String quoteText;
  final String quoteDate;
  final String quoteAuthor;
  Quote({required this.quoteText, required this.quoteDate, required this.quoteAuthor});

  factory Quote.fromJson(Map<String, dynamic> json){
    return Quote(
      quoteText: json['quote']['body'],
      quoteDate: json['qotd_date'],
      quoteAuthor: json['quote']['author']
    );
  }
}