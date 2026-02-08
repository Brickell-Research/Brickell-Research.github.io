◊(require pollen/template pollen/core)
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>◊(let ([title (select-from-metas 'title metas)]) (if title (format "~a · Brickell Research" title) "Brickell Research"))</title>
  <link rel="icon" type="image/png" href="brickell_research_logo.png">
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <header>
    <img src="brickell_research_logo.png" alt="Brickell Research" class="logo">
    <h1><a href="index.html">Brickell Research</a></h1>
    <p class="tagline">Systems thinking, without the thinking.</p>
    ◊(if (select-from-metas 'title metas) "" "<p class=\"manifesto-comment\"><a href=\"manifesto.html\"># our manifesto</a></p>")
  </header>
  <main>
    ◊(->html doc)
  </main>
  <footer>
    <p>Website powered by <a href="https://docs.racket-lang.org/pollen/">Pollen</a></p>
  </footer>
</body>
</html>
