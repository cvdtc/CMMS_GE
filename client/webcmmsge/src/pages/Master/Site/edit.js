import React, {useState, useEffect} from 'react';
/// import react router dom
/// import react router dom
import { useLocation, useNavigate } from "react-router-dom";
import swal from 'sweetalert';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// import axios
import axios from "../../../utils/server";


const EditSite = () => {
    /// define form state
    const [idsite, setIdSite] = useState("");
    const [nama, setNama] = useState("");
    const [keterangan, setKeterangan] = useState("");
    
/// previous page handler
const history = useNavigate()

/// set value from props
const location = useLocation()
    useEffect(() => {
        /// set value from props
        setIdSite(location.state.data.idsite)
        setNama(location.state.data.nama)
        setKeterangan(location.state.data.keterangan)
    }, [location])

    
/// action konfirmasi
const KonfirmasiData = async (e) => {
    swal({
        title: `Yakin menyimpan data ${nama}?`,
        text: "Pastikan data yang anda hapus sudah sesuai!",
        icon: "warning",
        buttons: true,
        dangerMode: true
    }).then((willDelete) => {
        if (willDelete) {
            sitePut(e)
        }
    });
}

/// post to api
const sitePut = async (e) => {
    /// event handler
    e.preventDefault();
    /// initialize json value
    const dataSite = {
        nama: nama,
        keterangan: keterangan
    };
    /// sending data json to api
    await axios
        .put("site/"+idsite, dataSite, {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        })
        .then((response) => {
            swal(`${response.data.message}`, {
                icon: "success",
            });
            history("/datasite");
        })
        .catch((error) => {
            swal(`${error.response.data}`, {
                icon: "error",
            });
        });
};

    return (
        <>
            {/* /// navigation bar */}
            <NavbarComponent />
            <div className="md:container lg:mx-auto  mt-3">
                {/* /// name page */}
                <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                    Edit Site
                </h1>
                {/* /// form design */}
                <form className='w-full' onSubmit={sitePut}>
                    {/* /// row 1 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// input nama site */}
                        <div className='w-full px-3'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Nama Mesin</label>
                            <input
                                type="text"
                                className='block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                placeholder='Nama Site'
                                required
                                value={nama}
                                onChange={(e) => setNama(e.target.value)} />
                        </div>
                    </div>
                    {/* /// row 2 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// input keterangan */}
                        <div className='w-full px-3'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Keterangan</label>
                            <input
                                type="text"
                                className='block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                placeholder='Keterangan'
                                required
                                value={keterangan}
                                onChange={(e) => setKeterangan(e.target.value)} />
                        </div>
                    </div>
                    {/* /// button simpan */}
                    <button type='button' onClick={(e)=>KonfirmasiData(e)} className='mt-8 w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-600'>Simpan</button>
                </form>
                {/* </div> */}
            </div>
        </>
    );
}

export default EditSite;
