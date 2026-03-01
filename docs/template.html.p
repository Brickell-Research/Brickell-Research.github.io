◊(require pollen/template pollen/core)
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>◊(let ([title (select-from-metas 'title metas)]) (if title (format "~a · Brickell Research" title) "Brickell Research"))</title>
  <meta name="description" content="◊(let ([title (select-from-metas 'title metas)]) (if title (format "~a — Brickell Research" title) "Independent research lab exploring the interaction between system reliability and programming languages."))">
  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:title" content="◊(let ([title (select-from-metas 'title metas)]) (if title (format "~a · Brickell Research" title) "Brickell Research"))">
  <meta property="og:description" content="Independent research lab exploring the interaction between system reliability and programming languages.">
  <meta property="og:image" content="https://brickellresearch.org/brickell_research_logo.png">
  <meta property="og:url" content="https://brickellresearch.org/">
  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary">
  <meta name="twitter:title" content="◊(let ([title (select-from-metas 'title metas)]) (if title (format "~a · Brickell Research" title) "Brickell Research"))">
  <meta name="twitter:description" content="Independent research lab exploring the interaction between system reliability and programming languages.">
  <meta name="twitter:image" content="https://brickellresearch.org/brickell_research_logo.png">
  <!-- Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "ResearchOrganization",
    "name": "Brickell Research",
    "url": "https://brickellresearch.org",
    "description": "Independent research lab exploring the interaction between system reliability and programming languages.",
    "founder": {
      "@type": "Person",
      "name": "Rob Durst"
    },
    "foundingDate": "2025",
    "logo": "https://brickellresearch.org/brickell_research_logo.png"
  }
  </script>
  <link rel="icon" type="image/png" href="brickell_research_logo.png">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <header>
    <a href="index.html"><img src="brickell_research_logo.png" alt="Brickell Research" class="logo"></a>
    <h1><a href="index.html">Brickell Research</a></h1>
    <p class="tagline">Systems thinking, without the thinking.</p>
    ◊(if (select-from-metas 'title metas) "" "<p class=\"manifesto-comment\"><a href=\"manifesto.html\"># our manifesto</a></p>")
  </header>
  <main>
    ◊(->html doc)
  </main>
  <footer>
    <p>Website powered by <a href="https://docs.racket-lang.org/pollen/">Pollen</a> · Research conducted by proud Gleamlins</p>
  </footer>
</body>
</html>
