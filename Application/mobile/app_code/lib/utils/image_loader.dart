/// This function is used to load the image of the article
/// according to the article name.
String imageLoader(String articleName) {
  switch (articleName) {
    case 'Ballon de volley':
      return 'assets/volley.png';
    case 'Raquette':
      return 'assets/raquette.jpg';
    case 'Ballon de football':
      return 'assets/football.jpg';
    case 'Freesbee':
      return 'assets/freesbee.jpg';
  }
  return 'assets/logo.png';
}
