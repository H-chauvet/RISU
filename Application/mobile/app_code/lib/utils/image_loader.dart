String imageLoader(String articleName, [int index = 0]) {
  if (index != 0) {
    switch (articleName) {
      case 'Ballon de volley':
        return 'assets/volley/$index.png';
      case 'Raquette':
        return 'assets/raquette/$index.png';
    }
  }
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
