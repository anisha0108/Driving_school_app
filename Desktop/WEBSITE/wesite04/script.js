function generateCertificate() {

    const name =
        document.getElementById("participantName").value;

    const event =
        document.getElementById("eventName").value;

    const type =
        document.getElementById("certificateType").value;

    const date =
        document.getElementById("eventDate").value;

    const organizer =
        document.getElementById("organizerName").value;

    const certificateId =
        document.getElementById("certificateId").value;


    // Participant name

    document.getElementById("previewName").textContent =
        name || "Your Name";


    // Event name

    document.getElementById("previewEvent").textContent =
        event || "Your Event Name";


    // Certificate type

    document.getElementById("previewType").textContent =
        type.replace("Certificate of ", "").toUpperCase();


    // Organizer

    document.getElementById("previewOrganizer").textContent =
        organizer || "Organizer";


    // Certificate ID

    document.getElementById("previewId").textContent =
        certificateId || "CERT-2026-001";


    // Date

    if (date) {

        const formattedDate =
            new Date(date).toLocaleDateString("en-IN", {
                day: "numeric",
                month: "long",
                year: "numeric"
            });

        document.getElementById("previewDate").textContent =
            formattedDate;

    } else {

        document.getElementById("previewDate").textContent =
            "Event Date";
    }
}