/* ==========================
SHETALL DRIVING SCHOOL
JAVASCRIPT
========================== */

/* ==========================
MOBILE MENU
========================== */

function toggleMenu() {

```
const navMenu = document.getElementById("navMenu");

navMenu.classList.toggle("active");
```

}

/* Close mobile menu after clicking link */

document.querySelectorAll("#navMenu a").forEach(function(link) {

```
link.addEventListener("click", function() {

    document.getElementById("navMenu").classList.remove("active");

});
```

});

/* ==========================
CURRENT YEAR
========================== */

document.getElementById("year").textContent =
new Date().getFullYear();

/* ==========================
FEEDBACK FORM
========================== */

const feedbackForm =
document.getElementById("feedbackForm");

const feedbackMessage =
document.getElementById("feedbackMessage");

feedbackForm.addEventListener("submit", function(event) {

```
event.preventDefault();


const name =
    document.getElementById("name").value.trim();

const phone =
    document.getElementById("phone").value.trim();

const feedback =
    document.getElementById("feedback").value.trim();

const rating =
    document.querySelector(
        'input[name="rating"]:checked'
    );


/* Validate rating */

if (!rating) {

    feedbackMessage.textContent =
        "Please select a rating.";

    feedbackMessage.style.color =
        "#ff3333";

    return;
}


/* Basic phone validation */

const phonePattern = /^[0-9]{10}$/;

if (!phonePattern.test(phone)) {

    feedbackMessage.textContent =
        "Please enter a valid 10-digit phone number.";

    feedbackMessage.style.color =
        "#ff3333";

    return;
}


/* Save feedback locally */

const feedbackData = {

    name: name,

    phone: phone,

    rating: rating.value,

    feedback: feedback,

    date: new Date().toLocaleString()

};


let feedbackList =
    JSON.parse(
        localStorage.getItem("shetallFeedback")
    ) || [];


feedbackList.push(feedbackData);


localStorage.setItem(
    "shetallFeedback",
    JSON.stringify(feedbackList)
);


/* Success message */

feedbackMessage.innerHTML =
    "✓ Thank you, " +
    name +
    "! Your feedback has been submitted.";

feedbackMessage.style.color =
    "#00d66b";


/* Reset form */

feedbackForm.reset();
```

});

/* ==========================
SCROLL REVEAL
========================== */

const revealElements =
document.querySelectorAll(
".course-card, .vehicle-card, .process-item, .stat-box, .contact-item"
);

const revealObserver =
new IntersectionObserver(

```
    function(entries) {

        entries.forEach(function(entry) {

            if (entry.isIntersecting) {

                entry.target.classList.add("show");

            }

        });

    },

    {
        threshold: 0.12
    }

);
```

revealElements.forEach(function(element) {

```
element.classList.add("reveal");

revealObserver.observe(element);
```

}),

/* ==========================
ACTIVE NAVIGATION
========================== */

const sections =
document.querySelectorAll("section[id]");

const navLinks =
document.querySelectorAll("#navMenu a");

window.addEventListener("scroll", function() {

```
let current = "";

sections.forEach(function(section) {

    const sectionTop =
        section.offsetTop - 120;

    if (window.scrollY >= sectionTop) {

        current = section.getAttribute("id");

    }

});


navLinks.forEach(function(link) {

    link.classList.remove("active");

    if (
        link.getAttribute("href") === "#" + current
    ) {

        link.classList.add("active");

    }

});
```

});

/* ==========================
PHONE NUMBER CLICK
========================== */

document.querySelectorAll('a[href^="tel:"]')
.forEach(function(button) {

```
button.addEventListener("click", function() {

    console.log(
        "Calling Shetall Driving School..."
    );

});
```

});
