import { Controller } from "stimulus";

export default class extends Controller {
  listUser(event) {
    const value = event.target.value;

    if (value.includes("%")) {
      return;
    }

    const loader = document.getElementById("loader");
    loader.style.display = "block";

    fetch("/users/list_user", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ user_type: value }),
    })
      .then((response) => response.text())
      .then((data) => {
        document.getElementById("user_information").innerHTML = data;
        loader.style.display = "none";
      })
      .catch((error) => {
        console.error("Error:", error);
        loader.style.display = "none";
      });
  }
}
