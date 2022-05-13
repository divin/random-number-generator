// Simple script to update the title of the header based on the current section which is viewed
// Version 1.0
// Written by Divin Gavran

// Get sections
const sections = document.querySelectorAll('div.section'); // Targets
const config = { rootMargin: '-50% 0% -50% 0%' }; // Configuration (old values: (-6% 0% -94% 0%))

// IO object
let observer = new IntersectionObserver(function (entries, self) {
	entries.forEach(entry => {
	  if (entry.isIntersecting) {
		intersectionHandler(entry); // If intersecting call intersection handler
	  }
	});
  }, config);

// Observe targets
sections.forEach(section => {
	observer.observe(section);
  });

// Intersection handler
function intersectionHandler(entry) {
	
	var id = entry.target.id;
	if (id == NaN) {
		id = "work"
	}
	
	var name = id;
	if (name == "e404") {
		name = "404";
	}
	
	$("#current").text("." + name);
}