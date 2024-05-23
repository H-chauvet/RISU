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
