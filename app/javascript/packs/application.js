/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import ActionCable from 'actioncable'
const onLoad= () => {
  const realtime_informer_element = document.querySelectorAll('.realtime-informer')[0];
  const clearInformer = () => {
    const stored_clear_at = parseInt(realtime_informer_element.getAttribute('clearAt'));
    const current_time = Date.now();
    if(current_time > stored_clear_at) {
      realtime_informer_element.innerHTML='';
    }
  }

  const updateInformer = (message) => {
    realtime_informer_element.innerHTML=message;
    realtime_informer_element.setAttribute('clearAt', `${Date.now()+5000}`)
  }

  setInterval(clearInformer, 1000);


  const cable = ActionCable.createConsumer('ws://localhost:3000/cable')
  let sub = cable.subscriptions.create('IndexingChannel', {
    received: updateInformer
  })

}

// `DOMContentLoaded` may fire before your script has a chance to run, so check before adding a listener
if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", onLoad);
} else {  // `DOMContentLoaded` already fired
    onLoad();
}
