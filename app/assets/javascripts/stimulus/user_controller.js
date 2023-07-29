import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['partial'];

  listUser(event) {
    const selectedValue = event.target.value;
    this.loadPartial(selectedValue);
  }

  loadPartial(selectedValue) {
    const partials = {
      '': '',
      'Admin': '/users/admin',
      'Employee': '/users/employee',
      'Student': '/users/student',
      'Parent': '/users/parent'
    };
    

    const partialUrl = partials[selectedValue];

    if (partialUrl) {
      fetch(partialUrl)
        .then(response => response.text())
        .then(html => {
          this.partialTarget.innerHTML = html;
        })
        .catch(error => {

          console.error('Error loading partial:', error);
        });
    } else {
      this.partialTarget.innerHTML = '';
    }
  }
}
