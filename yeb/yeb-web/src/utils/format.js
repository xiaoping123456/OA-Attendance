export const formatDateFull = (str) =>{
    if (str == '')return '';
    let date = new Date(str);
    return date.getFullYear()+"-"+
        date.getMonth()+"-"+
        date.getDate()+
        " "+
        date.getHours()+":"+
        date.getMinutes()+":"+
        date.getSeconds();
}

export const formatDate = (str) =>{
    if (str == '')return '';
    let date = new Date(str);
    return date.getFullYear()+"-"+
        date.getMonth()+"-"+
        date.getDate()
}
