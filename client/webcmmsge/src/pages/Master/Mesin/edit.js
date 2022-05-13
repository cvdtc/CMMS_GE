import React, { useEffect, useState } from 'react';

/// import axios 
import axios from '../../../utils/server';

/// import react router dom
import { useLocation, useNavigate } from "react-router-dom";

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// combobox react for load data mesin
import AsyncSelect from 'react-select/async'
import swal from 'sweetalert';


const EditMesin = () => {
    /// getting parameters from url
    const [idmesin, setIdMesin] = useState("")
    const [idsite, setIdSite] = useState("")
    const [namasite, setNamaSite] = useState("")
    const [nomesin, setNoMesin] = useState("")
    const [keterangan, setKeterangan] = useState("")

    const location = useLocation()
    useEffect(() => {
        /// set value from props
        setIdMesin(location.state.data.idmesin)
        setIdSite(location.state.data.idsite)
        setNamaSite(location.state.data.site)
        setNoMesin(location.state.data.nomesin)
        setKeterangan(location.state.data.keterangan)
    }, [location])

    /// previous page handler
    const history = useNavigate()

    /// set value combobox site from api
    const onChange = (value) => {
        setIdSite(value.idsite)
        setIdSite(value ? value.idsite : "");
        setNamaSite(value ? value.nama : "");
    }

/// modal konfirmasi
const KonfirmasiData = async (e) => {
    swal({
        title: `Yakin memperbarui ${nomesin}?`,
        text: "Pastikan data yang anda masukkan sudah sesuai!",
        icon: "warning",
        buttons: true,
        dangerMode: true,
        closeOnClickOutside: false,
        closeOnEsc: false,
    }).then((willDelete) => {
        if (willDelete) {
            mesinPut(e)
        }
    });
}
    
    /// post to api
    const mesinPut = async (e) => {
        /// event handler
        e.preventDefault();
        /// initialize json value
        const datamesin = {
            nomesin: nomesin,
            keterangan: keterangan,
            idsite: idsite
        };
        /// sending data json to api
        await axios
            .put("mesin/" + idmesin, datamesin, {
                headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
            })
            .then((response) => {
                swal(`Sorry! ${response.data.message}`, {
                    icon: "success",
                });
                history("/datamesin");
            })
            .catch((error) => {
                swal(`Sorry! ${error.response.message}`, {
                    icon: "error",
                });
            });
    };

    /// getting data site from api for dropdown site
    const loadSite = () => {
        return axios.get("site", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            const respon = response.data.data
            return respon
        }).catch((error) => {
            swal(`Sorry! ${error.response.message}`, {
                icon: "error",
            });
        }).finally(() => {
        })
    }

    return (
        <>
            {/* /// navigation bar */}
            <NavbarComponent />
            <div className="md:container lg:mx-auto  mt-3">
                {/* /// name page */}
                <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                    Edit Mesin
                </h1>
                {/* /// form design */}
                <form className='w-full'>
                    {/* /// row 1 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        <div className='w-full px-3'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Mesin</label>
                            <div className='relative'>
                                <AsyncSelect
                                    inputValue={namasite}
                                    onChange={onChange}
                                    cacheOptions
                                    defaultOptions
                                    getOptionLabel={e => e.nama}
                                    getOptionValue={e => e.idsite}
                                    loadOptions={loadSite}
                                    placeholder="Pilih Site..."
                                />
                            </div>
                        </div>
                    </div>
                    {/* /// row 2 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// input nomor mesin */}
                        <div className='w-full px-3'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Nomor Mesin</label>
                            <input
                                type="text"
                                className='block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                placeholder='Nomor Mesin'
                                value={nomesin}
                                required
                                onChange={(e) => setNoMesin(e.target.value)} />
                        </div>
                    </div>
                    {/* /// row 3 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// input keterangan */}
                        <div className='w-full px-3'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Keterangan</label>
                            <input
                                type="text"
                                className='appearance-none block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                placeholder='Keterangan'
                                required
                                value={keterangan}
                                onChange={(e) => setKeterangan(e.target.value)} />
                        </div>
                    </div>
                    {/* /// button simpan */}
                    <button type='button' onClick={(e) => KonfirmasiData(e)} data-modal-toggle="popup-modal" className='mt-8 w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-600'>Simpan</button>

                </form>
            </div>
        </>
    );
}

export default EditMesin;
